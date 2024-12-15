defmodule CalculatorFinance.Utils.Formatter do
  @moduledoc """
  Modul untuk memformat output dari berbagai perhitungan.
  """

  @doc """
  Membulatkan nilai mata uang ke 2 desimal.
  """
  @spec round_currency(number()) :: float()
  # def round_currency(number) do
  #   Float.round(number, 2)
  # end
  def round_currency(number) when is_number(number) do
    # Konversi ke float
    (number * 1.0)
    |> Float.round(2)
  end

  @doc """
  Membulatkan nilai ke jumlah desimal yang ditentukan.
  """
  @spec round_decimal(number(), non_neg_integer()) :: float()
  # def round_decimal(number, decimal_places) do
  #   Float.round(number, decimal_places)
  # end
  def round_decimal(number, decimal_places) when is_number(number) do
    # Konversi ke float
    (number * 1.0)
    |> Float.round(decimal_places)
  end

  @doc """
  Memformat angka ke format mata uang Indonesia.
  """
  @spec format_rupiah(number()) :: String.t()
  def format_rupiah(number) do
    "Rp#{:erlang.float_to_binary(round_currency(number), decimals: 2)}"
    |> String.replace(".", ",")
  end
end
