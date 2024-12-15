defmodule CalculatorFinance.CompoundInterestTest do
  use ExUnit.Case
  doctest CalculatorFinance.CompoundInterest

  alias CalculatorFinance.CompoundInterest

  describe "calculate/3" do
    test "menghitung bunga majemuk dengan benar untuk kasus dasar" do
      # Skenario: Investasi 1 juta rupiah dengan bunga 10% selama 1 tahun
      # Menggunakan kapitalisasi bulanan (12 kali setahun)
      {:ok, result} = CalculatorFinance.CompoundInterest.calculate(1_000_000, 10, 1)

      # Hasil yang diharapkan dihitung menggunakan rumus:
      # A = P(1 + r/n)^(nt)
      # A = 1,000,000(1 + 0.10/12)^(12 * 1)
      # A ≈ 1,104,713.07
      expected = 1_104_713.07

      # Menggunakan assert_in_delta karena perhitungan floating point
      # Toleransi 0.1 berarti perbedaan hingga 10 sen masih diterima
      assert_in_delta result, expected, 0.1
    end

    test "menghitung bunga majemuk untuk periode lebih panjang" do
      # Skenario: Investasi 1 juta rupiah dengan bunga 5% selama 2 tahun
      {:ok, result} = CalculatorFinance.CompoundInterest.calculate(1_000_000, 5, 2)

      # A = 1,000,000(1 + 0.05/12)^(12 * 2)
      # A ≈ 1,104,941.34
      expected = 1_104_941.34
      assert_in_delta result, expected, 0.1
    end

    test "menghitung dengan frekuensi kapitalisasi yang berbeda" do
      # Membandingkan hasil antara kapitalisasi bulanan dan tahunan
      # bulanan
      {:ok, monthly} = CalculatorFinance.CompoundInterest.calculate(1_000_000, 10, 1, 12)
      # tahunan
      {:ok, yearly} = CalculatorFinance.CompoundInterest.calculate(1_000_000, 10, 1, 1)

      # Kapitalisasi bulanan seharusnya menghasilkan nilai yang lebih tinggi
      assert monthly > yearly
    end

    test "menolak input negatif" do
      # Menguji validasi untuk setiap parameter
      assert {:error, _} = CalculatorFinance.CompoundInterest.calculate(-1_000_000, 10, 1)
      assert {:error, _} = CalculatorFinance.CompoundInterest.calculate(1_000_000, -10, 1)
      assert {:error, _} = CalculatorFinance.CompoundInterest.calculate(1_000_000, 10, -1)
    end
  end

  describe "time_to_reach/3" do
    test "menghitung waktu untuk menggandakan investasi" do
      # Berapa lama untuk mengubah 1 juta menjadi 2 juta dengan bunga 10%
      {:ok, years} = CalculatorFinance.CompoundInterest.time_to_reach(1_000_000, 10, 2_000_000)

      # Hasil seharusnya sekitar 6.96  tahun
      assert_in_delta years, 6.96, 0.01
    end

    test "menolak target yang lebih kecil dari principal" do
      assert {:error, "Target amount harus lebih besar dari principal"} =
               CalculatorFinance.CompoundInterest.time_to_reach(1_000_000, 10, 500_000)
    end
  end

  describe "calculate_growth_projection/3" do
    test "menghitung proyeksi pertumbuhan dengan benar" do
      {:ok, projections} = CompoundInterest.calculate_growth_projection(1_000_000, 10, 3)

      # Memastikan jumlah periode sesuai
      assert length(projections) == 3

      # Memastikan nilai meningkat setiap tahun
      [year1, year2, year3] = projections
      assert year2 > year1
      assert year3 > year2
    end

    test "hasil proyeksi sesuai dengan perhitungan individual" do
      {:ok, [year1, year2]} = CompoundInterest.calculate_growth_projection(1_000_000, 10, 2)
      {:ok, direct_year1} = CalculatorFinance.CompoundInterest.calculate(1_000_000, 10, 1)
      {:ok, direct_year2} = CalculatorFinance.CompoundInterest.calculate(1_000_000, 10, 2)

      assert_in_delta year1, direct_year1, 0.1
      assert_in_delta year2, direct_year2, 0.1
    end
  end

  describe "analyze_growth/4" do
    test "menganalisis keuntungan dengan fungsi kustom" do
      # Fungsi untuk menghitung keuntungan absolut
      profit_fn = fn amount -> amount - 1_000_000 end

      {:ok, profits} = CompoundInterest.analyze_growth(1_000_000, 10, 2, profit_fn)

      # Memastikan keuntungan positif dan meningkat
      [profit1, profit2] = profits
      assert profit1 > 0
      assert profit2 > profit1
    end

    test "menghitung persentase pertumbuhan" do
      # Fungsi untuk menghitung persentase pertumbuhan
      percentage_fn = fn amount -> (amount - 1_000_000) / 1_000_000 * 100 end

      {:ok, percentages} = CompoundInterest.analyze_growth(1_000_000, 10, 2, percentage_fn)

      # Memastikan persentase meningkat
      [pct1, pct2] = percentages
      assert pct1 > 0
      assert pct2 > pct1
    end
  end
end
