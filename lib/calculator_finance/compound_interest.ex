# Modul bunga majemuk

defmodule CalculatorFinance.CompoundInterest do
  @moduledoc """
  Modul untuk perhitungan dan analisis bunga majemuk (compound interest).

  Modul ini menyediakan serangkaian fungsi untuk melakukan perhitungan keuangan
  terkait bunga majemuk, termasuk:

  1. Perhitungan Dasar:
     - Menghitung akumulasi investasi dengan bunga majemuk
     - Menghitung waktu yang dibutuhkan untuk mencapai target investasi

  2. Analisis dan Proyeksi:
     - Simulasi pertumbuhan investasi untuk beberapa periode
     - Analisis kustom menggunakan fungsi yang dapat disesuaikan

  3. Fitur Utama:
     - Mendukung frekuensi kapitalisasi yang dapat disesuaikan (bulanan, tahunan, dll)
     - Validasi input untuk memastikan perhitungan yang akurat
     - Hasil perhitungan dibulatkan ke 2 desimal untuk kepraktisan
     - Format output yang konsisten dengan standar keuangan

  ## Contoh Penggunaan Dasar

      # Menghitung bunga majemuk
      iex> CalculatorFinance.CompoundInterest.calculate(1_000_000, 10, 2)
      {:ok, 1_220_390.96}

      # Menghitung waktu untuk mencapai target
      iex> CalculatorFinance.CompoundInterest.time_to_reach(1_000_000, 10, 2_000_000)
      {:ok, 6.96}

      # Proyeksi pertumbuhan
      iex> CalculatorFinance.CompoundInterest.calculate_growth_projection(1_000_000, 10, 3)
      {:ok, [1_104_713.07, 1_220_390.96, 1_348_181.84]}

  ## Formula yang Digunakan

  Perhitungan bunga majemuk menggunakan rumus:
  A = P(1 + r/n)^(nt)

  Di mana:
  - A = Jumlah akhir
  - P = Principal (nilai pokok)
  - r = Rate (suku bunga dalam desimal)
  - n = Frequency (frekuensi kapitalisasi per tahun)
  - t = Time (waktu dalam tahun)
  """

  alias CalculatorFinance.Utils.Validation
  alias CalculatorFinance.Utils.Formatter

  @type principal :: number()
  @type rate :: float()
  @type time :: number()
  @type frequency :: pos_integer()

  # Public Functions - Interface utama yang digunakan oleh pengguna

  @doc """
  Menghitung akumulasi investasi dengan bunga majemuk.

  Fungsi ini melakukan perhitungan bunga majemuk berdasarkan parameter yang diberikan
  dan mengembalikan hasil dalam format tuple {:ok, result} atau {:error, message}.

  ## Parameters

    * `principal` - Nilai pokok investasi awal (dalam mata uang yang sama)
    * `rate` - Suku bunga tahunan (dalam persen, misal 10 untuk 10%)
    * `time` - Jangka waktu investasi (dalam tahun, mendukung nilai desimal)
    * `frequency` - Frekuensi kapitalisasi per tahun (default: 12 untuk bulanan)

  ## Returns

    * `{:ok, float()}` - Tuple berisi hasil perhitungan yang sudah dibulatkan
    * `{:error, String.t()}` - Tuple berisi pesan error jika validasi gagal

  ## Examples

      # Investasi 1 juta dengan bunga 10% selama 2 tahun (kapitalisasi bulanan)
      iex> CalculatorFinance.CompoundInterest.calculate(1_000_000, 10, 2)
      {:ok, 1_220_390.96}

      # Dengan kapitalisasi tahunan
      iex> CalculatorFinance.CompoundInterest.calculate(1_000_000, 10, 2, 1)
      {:ok, 1_210_000.00}

      # Dengan input negatif
      iex> CalculatorFinance.CompoundInterest.calculate(-1000, 10, 2)
      {:error, "Input harus berupa angka positif"}

  ## Algoritma

  1. Validasi semua input untuk memastikan nilainya positif
  2. Konversi rate dari persen ke desimal (dibagi 100)
  3. Hitung exponent = frequency * time
  4. Hitung base = 1 + (rate_decimal / frequency)
  5. Hasil akhir = principal * (base ^ exponent)

  ## Catatan Penting

  - Hasil perhitungan dibulatkan ke 2 desimal
  - Frekuensi kapitalisasi mempengaruhi hasil akhir
  - Semakin tinggi frekuensi, semakin tinggi hasil akhir
  """
  @spec calculate(principal(), rate(), time(), frequency()) ::
          {:ok, float()} | {:error, String.t()}
  def calculate(principal, rate, time, frequency \\ 12) do
    with {:ok, _} <- validate_inputs(principal, rate, time) do
      result = compute_compound_interest(principal, rate, time, frequency)
      {:ok, Formatter.round_currency(result)}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  @doc """
  Menghitung waktu yang dibutuhkan untuk mencapai target jumlah dengan bunga majemuk.

  ## Parameters
    - principal: Nilai pokok investasi awal
    - rate: Suku bunga tahunan (dalam persen)
    - target_amount: Jumlah target yang ingin dicapai
    - frequency: Frekuensi kapitalisasi per tahun (default: 12 untuk bulanan)

  ## Examples
      iex> CalculatorFinance.CompoundInterest.time_to_reach(1000000, 10, 2000000)
      {:ok, 6.96} # Sekitar 6.96 tahun untuk menggandakan investasi dengan bunga 10%
  """
  @spec time_to_reach(principal(), rate(), number(), frequency()) ::
          {:ok, float()} | {:error, String.t()}
  def time_to_reach(principal, rate, target_amount, frequency \\ 12) do
    with {:ok, _} <- Validation.validate_positive_number(principal),
         {:ok, _} <- Validation.validate_positive_number(rate),
         {:ok, _} <- Validation.validate_positive_number(target_amount),
         :ok <- validate_target(principal, target_amount) do
      result = compute_time_to_reach(principal, rate, target_amount, frequency)
      {:ok, Formatter.round_decimal(result, 2)}
    end
  end

  # def time_to_reach(principal, rate, target_amount, frequency \\ 12) do
  #   with {:ok, _} <- Validation.validate_positive_number(principal),
  #        {:ok, _} <- Validation.validate_positive_number(rate),
  #        {:ok, _} <- Validation.validate_positive_number(target_amount) do
  #     r = rate / 100 / frequency
  #     t = :math.log(target_amount / principal) / (:math.log(1 + r) * frequency)

  #     {:ok, Formatter.round_decimal(t, 2)}
  #   else
  #     {:error, msg} -> {:error, msg}
  #   end
  # end

  @doc """
  Menghitung proyeksi pertumbuhan investasi untuk beberapa periode.
  Fungsi ini mengembalikan daftar nilai investasi untuk setiap periode yang ditentukan.

  ## Parameters
    - principal: Nilai pokok investasi awal
    - rate: Suku bunga tahunan (dalam persen)
    - periods: Jumlah periode yang ingin dihitung

  ## Examples
      iex> CalculatorFinance.CompoundInterest.calculate_growth_projection(1000000, 10, 3)
      {:ok, [1104713.07, 1220390.96, 1348181.84]}

  ## Penjelasan
  Fungsi ini akan menghitung nilai investasi pada:
  - Akhir tahun pertama
  - Akhir tahun kedua
  - Dan seterusnya hingga periode yang ditentukan
  """
  @spec calculate_growth_projection(principal(), rate(), pos_integer()) ::
          {:ok, list(float())} | {:error, String.t()}
  def calculate_growth_projection(principal, rate, periods) do
    with {:ok, _} <- validate_inputs(principal, rate, periods) do
      results =
        1..periods
        |> Enum.map(fn period ->
          # Menggunakan nilai default 12 untuk frequency
          compute_compound_interest(principal, rate, period, 12)
        end)
        |> Enum.map(&Formatter.round_currency/1)

      {:ok, results}
    end
  end

  @doc """
  Higher-Order Function yang memungkinkan aplikasi fungsi kustom
  pada hasil perhitungan bunga majemuk.
  """
  @spec analyze_growth(principal(), rate(), pos_integer(), function()) ::
          {:ok, list(float())} | {:error, String.t()}
  def analyze_growth(principal, rate, periods, analysis_fn) when is_function(analysis_fn, 1) do
    with {:ok, results} <- calculate_growth_projection(principal, rate, periods) do
      analyzed_results = Enum.map(results, analysis_fn)
      {:ok, analyzed_results}
    end
  end

  # Private Functions - Fungsi helper internal

  defp validate_target(principal, target_amount) do
    if target_amount <= principal do
      {:error, "Target amount harus lebih besar dari principal"}
    else
      :ok
    end
  end

  defp validate_inputs(principal, rate, time) do
    with {:ok, _} <- Validation.validate_positive_number(principal),
         {:ok, _} <- Validation.validate_positive_number(rate),
         {:ok, _} <- Validation.validate_positive_number(time) do
      {:ok, true}
    end
  end

  defp compute_compound_interest(principal, rate, time, frequency) do
    rate_decimal = rate / 100
    exponent = frequency * time
    base = 1 + rate_decimal / frequency
    principal * :math.pow(base, exponent)
  end

  # Menambahkan fungsi private compute_time_to_reach
  @doc false
  defp compute_time_to_reach(principal, rate, target_amount, frequency) do
    # Rumus: t = ln(Target/Principal) / (n * ln(1 + r/n))
    # di mana:
    # t = waktu dalam tahun
    # Target = jumlah target
    # Principal = nilai awal
    # r = suku bunga dalam desimal
    # n = frekuensi kapitalisasi per tahun

    # Konversi persen ke desimal
    rate_decimal = rate / 100
    r = rate_decimal / frequency

    # Perhitungan logaritma natural
    numerator = :math.log(target_amount / principal)
    denominator = frequency * :math.log(1 + r)

    # Hasil akhir dalam tahun
    numerator / denominator
  end
end
