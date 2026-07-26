describe ColorfulExceptions do
  let(:g) { "\e[#{32}m" }
  let(:c) { "\e[#{36}m" }
  let(:e) { "\e[0m" }

  it "prints colorful exceptions" do
    # Only frames from the eval'd source are checked. Frames above it name the
    # enclosing rspec block, and frames for core methods may live in Ruby
    # internals (`Integer#times` moved to <internal:numeric> in ruby 3.3).
    source = "def inner\n1/0\nend\ndef outer\ninner\nend\nouter\n"
    exception = (eval(source, nil, "/lib/test.rb", 1) rescue $!)
    expect(exception.backtrace[0]).to eq(
      "#{g}/lib/test.rb#{e}:#{g}2#{e}: in `#{c}/#{e}'"
    )
    expect(exception.backtrace[1]).to eq(
      "#{g}/lib/test.rb#{e}:#{g}2#{e}: in `#{c}inner#{e}'"
    )
    expect(exception.backtrace[2]).to eq(
      "#{g}/lib/test.rb#{e}:#{g}5#{e}: in `#{c}outer#{e}'"
    )
  end

  it "nil backtrace" do
    exception = RuntimeError.new("fail")
    expect(exception.backtrace).to eq(nil)
  end

  it "weird backtrace still mostly works" do
    exception = RuntimeError.new("fail")
    exception.set_backtrace([
      "/lib/foo.rb:1: in `times'",
      "/lib/bar.rb:2",
      "somewhere",
    ])
    # What set_backtraace is doing exactly...
    expect(exception.backtrace[0]).to eq(
      "#{g}/lib/foo.rb#{e}:#{g}1#{e}"
    )
    expect(exception.backtrace[1]).to eq(
      "#{g}/lib/bar.rb#{e}:#{g}2#{e}"
    )
    expect(exception.backtrace[2]).to eq(
      "#{g}somewhere#{e}"
    )
  end
end
