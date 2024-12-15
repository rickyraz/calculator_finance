# Modul konversi mata uang

defmodule CalculatorFinance.CurrencyConverter do
  @moduledoc """
  Modul untuk melakukan konversi mata uang dengan kurs yang dapat diperbarui.
  """

  alias CalculatorFinance.Utils.Validation
  alias CalculatorFinance.Utils.Formatter

  # Menyimpan kurs dasar (terhadap IDR)
  @exchange_rates %{
    usd: 15500,
    eur: 18000,
    sgd: 11500,
    myr: 3500,
    jpy: 140
  }

  @doc """
  Melakukan konversi mata uang.

  ## Examples
      iex> CurrencyConverter.convert(100, :usd, :idr)
      {:ok, 1550000.00}
  """
  @spec convert(number(), atom(), atom()) :: {:ok, float()} | {:error, String.t()}
  # def convert(amount, from_currency, to_currency) do
  #   with {:ok, _} <- Validation.validate_positive_number(amount),
  #        {:ok, rate} <- get_conversion_rate(from_currency, to_currency) do
  #     result = amount * rate
  #     {:ok, Formatter.round_currency(result)}
  #   else
  #     {:error, msg} -> {:error, msg}
  #   end
  # end

  def convert(amount, from_currency, to_currency) do
    with {:ok, _} <- Validation.validate_positive_number(amount),
         {:ok, rate} <- get_conversion_rate(from_currency, to_currency) do
      # Memastikan hasilnya float
      result = amount * rate * 1.0
      {:ok, Formatter.round_currency(result)}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  # Fungsi private untuk mendapatkan kurs konversi
  defp get_conversion_rate(from, to) when from == to, do: {:ok, 1.0}

  defp get_conversion_rate(:idr, to) when is_map_key(@exchange_rates, to) do
    {:ok, 1 / @exchange_rates[to]}
  end

  defp get_conversion_rate(from, :idr) when is_map_key(@exchange_rates, from) do
    {:ok, @exchange_rates[from]}
  end

  defp get_conversion_rate(from, to)
       when is_map_key(@exchange_rates, from) and is_map_key(@exchange_rates, to) do
    rate = @exchange_rates[from] / @exchange_rates[to]
    {:ok, rate}
  end

  defp get_conversion_rate(_, _) do
    {:error, "Mata uang tidak didukung"}
  end
end
