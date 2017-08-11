describe ColorfulExceptions do
  let(:g) { "\e[#{32}m" }
  let(:c) { "\e[#{36}m" }
  let(:e) { "\e[0m" }

  it "prints colorful exceptions" do
    exception = (eval("1.times{\n1/0\n}", nil, "/lib/test.rb", 1) rescue $!)
    expect(exception.backtrace[0]).to eq(
      "#{g}/lib/test.rb#{e}:#{g}2#{e}: in `#{c}/#{e}'"
    )
    expect(exception.backtrace[1]).to eq(
      "#{g}/lib/test.rb#{e}:#{g}2#{e}: in `#{c}block (3 levels) in <top (required)>#{e}'"
    )
    expect(exception.backtrace[2]).to eq(
      "#{g}/lib/test.rb#{e}:#{g}1#{e}: in `#{c}times#{e}'"
    )
    expect(exception.backtrace[3]).to eq(
      "#{g}/lib/test.rb#{e}:#{g}1#{e}: in `#{c}block (2 levels) in <top (required)>#{e}'"
    )
  end
end
