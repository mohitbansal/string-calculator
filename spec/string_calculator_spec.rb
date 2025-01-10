require 'string_calculator'

RSpec.describe StringCalculator do
  let(:calculator) { StringCalculator.new }
  describe "#add" do
    it "adds numbers" do
      expect(calculator).to receive(:numbers_from_string).with("1,2") { [1, 2] }
      expect(calculator.add("1,2")).to eq(3)
    end

    context "with negative numbers" do
      it "raises error" do
        allow(calculator).to receive(:numbers_from_string) { [-45, 1, 2, -25, 35] }
        expect{calculator.add("-45,1,2,-25,35")}.to raise_error("negatives not allowed - -45, -25")
      end
    end

    it "ignores numbers greater than 1000" do
      allow(calculator).to receive(:numbers_from_string) { [1, 2, 1001, 3]}
      expect(calculator.add("1,2,1001,3")).to eq(6)
    end

    it "returns 0 with empty string" do
      allow(calculator).to receive(:numbers_from_string) { [] }
      expect(calculator.add("")).to eq(0)
    end
  end

  describe "#numbers_from_string" do
    it "returns empty array with empty string" do
      expect(calculator.send(:numbers_from_string, "")).to be_empty
    end

    it "returns empty array with only newlines" do
      expect(calculator.send(:numbers_from_string, "\n")).to be_empty
    end

    it "returns array with single element when single number passed" do
      expect(calculator.send(:numbers_from_string, "1")).to eq([1])
    end

    it "parses numbers from given string with multiple comma separated numbers" do
      res = calculator.send(:numbers_from_string, "1,2,-3,-4,5,45.3,-5.67")
      expect(res).to eq([1,2,-3,-4,5, 45.3, -5.67])
    end

    it "parses numbers with newline between numbers" do
      res = calculator.send(:numbers_from_string, "1\n2,3")
      expect(res).to eq([1,2,3])
    end

    context "with different delimiter" do
      it "parses numbers" do
        res = calculator.send(:numbers_from_string, "//;\n10;2")
        expect(res).to eq([10,2])
      end

      context "with multiple character delimiter" do
        it "parses numbers" do
          res = calculator.send(:numbers_from_string, "//[***]\n10***25***35\n1***2\n-25***-9")
          expect(res).to eq([10, 25, 35, 1, 2,-25,-9])
        end
      end

      context "with multiple delimiters" do
        it "parses numbers" do
          res = calculator.send(:numbers_from_string, "//[***][%%]\n10***25%%35%%1***2")
          expect(res).to eq([10, 25, 35, 1, 2])
        end
      end

      context "with empty line after delimiter" do
        it "returns empty array" do
          res = calculator.send(:numbers_from_string, "//[***]\n")
          expect(res).to eq([])
        end
      end

      context "with invalid delimiter format" do
        it "raises error" do
          expect {calculator.send(:numbers_from_string, "//[***\n") }.to raise_error("invalid format")
        end
      end
    end

    it "raises error with invalid format" do
      expect {calculator.send(:numbers_from_string, "123\n,45") }.to raise_error("invalid format")
    end
  end
end