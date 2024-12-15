# Modul perhitungan pinjaman

defmodule CalculatorFinance.LoanCalculator do
  @moduledoc """
  Modul untuk menghitung berbagai aspek pinjaman seperti cicilan dan total pembayaran.
  """

  alias CalculatorFinance.Utils.Validation
  alias CalculatorFinance.Utils.Formatter

  @type loan_amount :: number()
  @type annual_rate :: float()
  @type years :: number()

  @doc """
  Menghitung cicilan bulanan dan informasi pinjaman lainnya.

  ## Parameters
    - loan_amount: Jumlah pinjaman
    - annual_rate: Suku bunga tahunan (dalam persen)
    - years: Jangka waktu pinjaman dalam tahun

  ## Examples
      iex> LoanCalculator.calculate_monthly_payment(100000000, 10, 5)
      {:ok, %{
        monthly_payment: 2124.70,
        total_payment: 127482.00,
        total_interest: 27482.00
      }}
  """
  @spec calculate_monthly_payment(loan_amount(), annual_rate(), years()) ::
          {:ok, map()} | {:error, String.t()}
  def calculate_monthly_payment(loan_amount, annual_rate, years) do
    with {:ok, _} <- Validation.validate_positive_number(loan_amount),
         {:ok, _} <- Validation.validate_positive_number(annual_rate),
         {:ok, _} <- Validation.validate_positive_number(years) do
      monthly_rate = annual_rate / 12 / 100
      num_payments = years * 12

      monthly_payment = calculate_pmt(loan_amount, monthly_rate, num_payments)
      total_payment = monthly_payment * num_payments
      total_interest = total_payment - loan_amount

      {:ok,
       %{
         monthly_payment: Formatter.round_currency(monthly_payment),
         total_payment: Formatter.round_currency(total_payment),
         total_interest: Formatter.round_currency(total_interest)
       }}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  # Fungsi helper untuk menghitung PMT (Payment)
  defp calculate_pmt(principal, monthly_rate, num_payments) do
    principal * monthly_rate * :math.pow(1 + monthly_rate, num_payments) /
      (:math.pow(1 + monthly_rate, num_payments) - 1)
  end
end
