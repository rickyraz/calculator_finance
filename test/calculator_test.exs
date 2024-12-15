defmodule CalculatorTest do
  use ExUnit.Case
  # Ini akan menguji contoh dalam dokumentasi
  doctest Calculator

  describe "calculate/3" do
    test "penambahan bekerja dengan benar" do
      assert Calculator.calculate(:add, 5, 1) == 6
      assert Calculator.calculate(:add, -1, 2) == 1
      assert Calculator.calculate(:add, 0, 0) == 0
    end

    test "pengurangan bekerja dengan benar" do
      assert Calculator.calculate(:subtract, 5, 3) == 2
      assert Calculator.calculate(:subtract, 1, 5) == -4
      assert Calculator.calculate(:subtract, 0, 0) == 0
    end

    test "perkalian bekerja dengan benar" do
      assert Calculator.calculate(:multiply, 4, 3) == 12
      assert Calculator.calculate(:multiply, -2, 3) == -6
      assert Calculator.calculate(:multiply, 0, 5) == 0
    end

    test "pembagian bekerja dengan benar" do
      assert Calculator.calculate(:divide, 6, 2) == 3.0
      assert Calculator.calculate(:divide, 5, 2) == 2.5
      assert Calculator.calculate(:divide, 0, 5) == 0.0
    end

    test "pembagian dengan nol mengembalikan pesan error" do
      assert Calculator.calculate(:divide, 5, 0) == {:error, "Tidak bisa membagi dengan nol"}
    end

    test "bekerja dengan bilangan negatif" do
      assert Calculator.calculate(:add, -5, -3) == -8
      assert Calculator.calculate(:subtract, -5, -3) == -2
      assert Calculator.calculate(:multiply, -5, -3) == 15
      assert Calculator.calculate(:divide, -6, -2) == 3.0
    end

    test "bekerja dengan bilangan desimal" do
      assert Calculator.calculate(:add, 2.5, 1.5) == 4.0
      assert Calculator.calculate(:subtract, 2.5, 1.5) == 1.0
      assert Calculator.calculate(:multiply, 2.5, 2.0) == 5.0
      assert Calculator.calculate(:divide, 5.0, 2.0) == 2.5
    end
  end
end
