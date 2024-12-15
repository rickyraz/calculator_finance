defmodule CalculatorFinance.CurrencyConverterTest do
  use ExUnit.Case
  alias CalculatorFinance.CurrencyConverter

  describe "convert/3" do
    test "konversi USD ke IDR bekerja dengan benar" do
      {:ok, result} = CurrencyConverter.convert(100, :usd, :idr)
      assert_in_delta result, 1_550_000.00, 0.01
    end

    test "konversi IDR ke USD bekerja dengan benar" do
      {:ok, result} = CurrencyConverter.convert(1_550_000, :idr, :usd)
      assert_in_delta result, 100.00, 0.01
    end

    test "konversi mata uang yang sama mengembalikan jumlah yang sama" do
      {:ok, result} = CurrencyConverter.convert(100, :usd, :usd)
      assert result == 100.00
    end

    test "menolak input negatif" do
      assert {:error, _} = CurrencyConverter.convert(-100, :usd, :idr)
    end

    test "menangani mata uang yang tidak didukung" do
      assert {:error, "Mata uang tidak didukung"} =
               CurrencyConverter.convert(100, :xyz, :idr)
    end
  end
end
