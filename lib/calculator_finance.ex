defmodule CalculatorFinance do
  @moduledoc """
  CalculatorFinance menyediakan berbagai fungsi perhitungan keuangan yang mencakup:
  - Perhitungan bunga majemuk
  - Konversi mata uang
  - Kalkulasi pinjaman
  - Perhitungan pajak penghasilan
  """

  alias CalculatorFinance.CompoundInterest
  alias CalculatorFinance.CurrencyConverter
  alias CalculatorFinance.LoanCalculator
  alias CalculatorFinance.TaxCalculator

  @doc """
  Mengembalikan versi aplikasi.

  ## Examples
      iex> CalculatorFinance.version()
      "0.1.0"
  """
  def version, do: "0.1.0"

  @doc """
  Menghitung bunga majemuk dengan parameter dasar.

  ## Examples
      iex> {:ok, result} = CalculatorFinance.calculate_compound_interest(1_000_000, 10, 1)
      iex> result >= 1_100_000.0 and result <= 1_110_000.0
      true
  """
  defdelegate calculate_compound_interest(principal, rate, time),
    to: CompoundInterest,
    as: :calculate

  @doc """
  Melakukan konversi mata uang.

  ## Examples
      iex> {:ok, result} = CalculatorFinance.convert_currency(100, :usd, :idr)
      iex> result >= 1_550_000.0 and result <= 1_560_000.0
      true
  """
  defdelegate convert_currency(amount, from_currency, to_currency),
    to: CurrencyConverter,
    as: :convert

  @doc """
  Menghitung informasi cicilan pinjaman.

  ## Examples
      iex> result = CalculatorFinance.calculate_loan(100_000, 10, 1)
      iex> match?({:ok, %{monthly_payment: _, total_payment: _, total_interest: _}}, result)
      true
  """
  defdelegate calculate_loan(principal, rate, years),
    to: LoanCalculator,
    as: :calculate_monthly_payment

  @doc """
  Menghitung pajak penghasilan tahunan.

  ## Examples
      iex> result = CalculatorFinance.calculate_tax(50_000_000)
      iex> match?({:ok, %{total_tax: _, effective_rate: _, breakdown: _}}, result)
      true
  """
  defdelegate calculate_tax(income),
    to: TaxCalculator,
    as: :calculate_income_tax
end
