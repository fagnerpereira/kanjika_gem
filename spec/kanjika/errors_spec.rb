# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Kanjika error classes" do
  it "defines Kanjika::Error as a StandardError" do
    expect(Kanjika::Error).to be < StandardError
  end

  it "defines Kanjika::InvalidVerbError as a Kanjika::Error" do
    expect(Kanjika::InvalidVerbError).to be < Kanjika::Error
  end
end
