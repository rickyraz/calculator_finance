defmodule CalculatorFinance.Utils.Validation do
  @moduledoc """
  Modul untuk validasi input pada berbagai perhitungan.
  """

  @doc """
  Memvalidasi bahwa input adalah angka positif.
  """
  @spec validate_positive_number(number()) :: {:ok, number()} | {:error, String.t()}
  def validate_positive_number(number) when is_number(number) and number > 0 do
    {:ok, number}
  end

  def validate_positive_number(_) do
    {:error, "Input harus berupa angka positif"}
  end

  @doc """
  Memvalidasi bahwa input berada dalam rentang yang ditentukan.
  """
  @spec validate_range(number(), number(), number()) ::
          {:ok, number()} | {:error, String.t()}
  def validate_range(number, min, max)
      when is_number(number) and number >= min and number <= max do
    {:ok, number}
  end

  def validate_range(_, min, max) do
    {:error, "Input harus berada dalam rentang #{min} sampai #{max}"}
  end
end
