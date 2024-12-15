defmodule CalculatorFinance.TaxCalculatorTest do
  use ExUnit.Case
  alias CalculatorFinance.TaxCalculator

  describe "calculate_income_tax/1" do
    test "menghitung pajak untuk pendapatan rendah" do
      {:ok, result} = TaxCalculator.calculate_income_tax(40_000_000)
      # 5% dari 40 juta
      assert_in_delta result.total_tax, 2_000_000, 0.01
      # Hanya satu bracket pajak
      assert length(result.breakdown) == 1
    end

    test "menghitung pajak untuk pendapatan menengah" do
      {:ok, result} = TaxCalculator.calculate_income_tax(100_000_000)
      # 50jt pertama: 5% = 2.5jt
      # 50jt kedua: 15% = 7.5jt
      # Total: 10jt
      assert_in_delta result.total_tax, 10_000_000, 0.01
      # Dua bracket pajak
      assert length(result.breakdown) == 2
    end

    test "effective rate dihitung dengan benar" do
      {:ok, result} = TaxCalculator.calculate_income_tax(100_000_000)
      expected_rate = result.total_tax / 100_000_000 * 100
      assert_in_delta result.effective_rate, expected_rate, 0.01
    end

    test "menolak input negatif" do
      assert {:error, _} = TaxCalculator.calculate_income_tax(-1000)
    end
  end
end
