defmodule Calculator do
  @moduledoc """
  Modul kalkulator sederhana yang menyediakan operasi aritmetika dasar.
  Menggunakan pattern matching untuk menentukan operasi yang akan dilakukan.
  """

  @doc """
  Melakukan perhitungan aritmetika dasar.

  ## Parameters
    - operator: atom yang menentukan operasi (:add, :subtract, :multiply, :divide)
    - a: angka pertama
    - b: angka kedua

  ## Examples
      iex> Calculator.calculate(:add, 5, 3)
      8

      iex> Calculator.calculate(:divide, 10, 2)
      5.0

      iex> Calculator.calculate(:divide, 10, 0)
      {:error, "Tidak bisa membagi dengan nol"}

  ## Pattern Matching
  Fungsi ini menggunakan pattern matching untuk:
  - Menangani kasus pembagian dengan nol secara khusus
  - Memilih operasi yang sesuai berdasarkan atom operator
  """
  def calculate(:add, a, b), do: a + b
  def calculate(:subtract, a, b), do: a - b
  def calculate(:multiply, a, b), do: a * b
  def calculate(:divide, _a, 0), do: {:error, "Tidak bisa membagi dengan nol"}
  def calculate(:divide, a, b), do: a / b
end
