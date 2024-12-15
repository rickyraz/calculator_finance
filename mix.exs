defmodule CalculatorFinance.MixProject do
  use Mix.Project

  def project do
    [
      app: :calculator_finance,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # Menambahkan deskripsi dan informasi package
      description: "Kalkulator keuangan dengan berbagai fitur perhitungan",
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      # Menambahkan dependensi yang diperlukan
      # Untuk dokumentasi
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      # Untuk perhitungan presisi tinggi
      {:decimal, "~> 2.0"},
      # Untuk analisis kode
      {:credo, "~> 1.6", only: [:dev, :test]}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{}
    ]
  end
end
