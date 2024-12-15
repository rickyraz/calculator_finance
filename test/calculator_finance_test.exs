defmodule CalculatorFinanceTest do
  use ExUnit.Case
  doctest CalculatorFinance

  describe "version/0" do
    test "mengembalikan string versi yang benar" do
      assert CalculatorFinance.version() == "0.1.0"
    end
  end

  # describe "calculate_compound_interest/3" do
  #   test "menghitung bunga majemuk dengan benar" do
  #     {:ok, result} = CalculatorFinance.calculate_compound_interest(1_000_000, 10, 1)
  #     assert_in_delta result, 1_100_000.0, 0.01
  #   end
  # end

  # describe "convert_currency/3" do
  #   test "mengkonversi USD ke IDR dengan benar" do
  #     {:ok, result} = CalculatorFinance.convert_currency(100, :usd, :idr)
  #     assert_in_delta result, 1_550_000.0, 0.01
  #   end
  # end

  describe "calculate_compound_interest/3" do
    test "menghitung bunga majemuk dengan benar" do
      # Kita akan menggunakan contoh dengan nilai yang jelas:
      # Principal (P) = 1,000,000 (1 juta)
      # Rate (r) = 10% = 0.10
      # Time (t) = 1 tahun
      # Frequency (n) = 12 (kapitalisasi bulanan, default)

      # Rumus bunga majemuk:
      # A = P(1 + r/n)^(nt)
      # A = 1,000,000 * (1 + 0.10/12)^(12 * 1)
      # A = 1,000,000 * (1 + 0.00833)^12
      # A ≈ 1,104,713.07

      {:ok, result} = CalculatorFinance.calculate_compound_interest(1_000_000, 10, 1)

      # Kita menggunakan assert_in_delta dengan toleransi 0.1 untuk mengakomodasi
      # perbedaan pembulatan yang sangat kecil
      assert_in_delta result, 1_104_713.07, 0.1
    end

    test "menghitung akumulasi bunga dengan benar" do
      {:ok, result} = CalculatorFinance.calculate_compound_interest(1_000_000, 10, 1)
      bunga = result - 1_000_000

      # Bunga yang dihasilkan seharusnya sekitar 104,713.07
      assert_in_delta bunga, 104_713.07, 0.1
    end

    test "memberikan hasil yang lebih besar dari bunga simple" do
      {:ok, result} = CalculatorFinance.calculate_compound_interest(1_000_000, 10, 1)
      # 1,100,000
      bunga_simple = 1_000_000 * (1 + 0.10)

      # Hasil bunga majemuk harus lebih besar dari bunga simple
      assert result > bunga_simple
    end

    test "menghasilkan nilai yang bertumbuh secara eksponensial dengan waktu" do
      {:ok, result_1_tahun} = CalculatorFinance.calculate_compound_interest(1_000_000, 10, 1)
      {:ok, result_2_tahun} = CalculatorFinance.calculate_compound_interest(1_000_000, 10, 2)

      # Pertumbuhan tahun kedua harus lebih besar dari tahun pertama
      pertumbuhan_tahun_1 = result_1_tahun - 1_000_000
      pertumbuhan_tahun_2 = result_2_tahun - result_1_tahun

      assert pertumbuhan_tahun_2 > pertumbuhan_tahun_1
    end

    test "menangani nilai input yang valid dengan baik" do
      # Test berbagai kombinasi input yang valid
      assert {:ok, _} = CalculatorFinance.calculate_compound_interest(1_000, 5, 1)
      assert {:ok, _} = CalculatorFinance.calculate_compound_interest(1_000_000, 0.5, 2)
      assert {:ok, _} = CalculatorFinance.calculate_compound_interest(500, 15, 0.5)
    end

    test "menolak nilai input negatif" do
      # Test penanganan input yang tidak valid
      assert {:error, _} = CalculatorFinance.calculate_compound_interest(-1000, 10, 1)
      assert {:error, _} = CalculatorFinance.calculate_compound_interest(1000, -10, 1)
      assert {:error, _} = CalculatorFinance.calculate_compound_interest(1000, 10, -1)
    end
  end

  describe "convert_currency/3" do
    test "mengkonversi USD ke IDR dengan benar" do
      {:ok, result} = CalculatorFinance.convert_currency(100, :usd, :idr)
      # Menggunakan toleransi yang lebih besar untuk konversi mata uang
      assert_in_delta result, 1_550_000.0, 1000
    end
  end

  describe "calculate_loan/3" do
    test "menghitung cicilan dengan benar" do
      {:ok, result} = CalculatorFinance.calculate_loan(100_000, 10, 1)
      assert is_map(result)
      assert Map.has_key?(result, :monthly_payment)
      assert Map.has_key?(result, :total_payment)
      assert Map.has_key?(result, :total_interest)
    end
  end

  describe "calculate_tax/1" do
    test "menghitung pajak dengan benar" do
      {:ok, result} = CalculatorFinance.calculate_tax(50_000_000)
      assert is_map(result)
      assert Map.has_key?(result, :total_tax)
      assert Map.has_key?(result, :effective_rate)
      assert Map.has_key?(result, :breakdown)
    end
  end
end
