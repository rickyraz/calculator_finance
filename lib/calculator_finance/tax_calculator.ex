# Modul perhitungan pajak

defmodule CalculatorFinance.TaxCalculator do
  @moduledoc """
  Modul untuk menghitung pajak penghasilan berdasarkan bracket pajak yang berlaku.
  """

  alias CalculatorFinance.Utils.Validation
  alias CalculatorFinance.Utils.Formatter

  # Definisi bracket pajak (dalam Rupiah)
  @tax_brackets [
    # 5% untuk 0-50jt
    {50_000_000, 0.05},
    # 15% untuk 50jt-250jt
    {250_000_000, 0.15},
    # 25% untuk 250jt-500jt
    {500_000_000, 0.25},
    # 30% untuk di atas 500jt
    {999_999_999_999, 0.30}
  ]

  @doc """
  Menghitung pajak penghasilan tahunan.

  ## Examples
      iex> TaxCalculator.calculate_income_tax(300_000_000)
      {:ok, %{
        total_tax: 45_000_000,
        effective_rate: 15.0,
        breakdown: [
          {50_000_000, 2_500_000},
          {200_000_000, 30_000_000},
          {50_000_000, 12_500_000}
        ]
      }}
  """
  def calculate_income_tax(annual_income) do
    with {:ok, _} <- Validation.validate_positive_number(annual_income) do
      {total_tax, breakdown} = calculate_tax_with_breakdown(annual_income)
      effective_rate = total_tax / annual_income * 100

      {:ok,
       %{
         total_tax: Formatter.round_currency(total_tax),
         effective_rate: Formatter.round_decimal(effective_rate, 2),
         breakdown: breakdown
       }}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  # Fungsi rekursif untuk menghitung pajak dengan breakdown
  defp calculate_tax_with_breakdown(income, brackets \\ @tax_brackets, acc \\ 0, breakdown \\ [])
  defp calculate_tax_with_breakdown(0, _, total, breakdown), do: {total, Enum.reverse(breakdown)}

  defp calculate_tax_with_breakdown(income, [{bracket, rate} | rest], total, breakdown) do
    taxable = min(income, bracket)
    tax = taxable * rate

    calculate_tax_with_breakdown(
      income - taxable,
      rest,
      total + tax,
      [{taxable, tax} | breakdown]
    )
  end
end
