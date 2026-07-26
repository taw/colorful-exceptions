describe ColorfulExceptions do
  let(:g) { "\e[#{32}m" }
  let(:c) { "\e[#{36}m" }
  let(:e) { "\e[0m" }
  # ruby up to 3.3 quotes the method as `name', ruby 3.4+ as 'Owner#name'
  let(:ruby_34) { Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4") }
  let(:q) { ruby_34 ? "'" : "`" }

  def label(owner, name)
    ruby_34 ? "#{owner}##{name}" : name
  end

  it "prints colorful exceptions" do
    # Only frames from the eval'd source are checked. Frames above it name the
    # enclosing rspec block, and frames for core methods may live in ruby
    # internals (`Integer#times` moved to <internal:numeric> in ruby 3.3).
    # The methods go in a named class so that ruby 3.4+ labels them
    # predictably -- defined bare here they would be owned by rspec's
    # anonymous example group class, which has no name to print.
    source = <<~RUBY
      class BacktraceProbe
        def inner
          1/0
        end
        def outer
          inner
        end
      end
      BacktraceProbe.new.outer
    RUBY
    exception = (eval(source, nil, "/lib/test.rb", 1) rescue $!)
    expect(exception.backtrace[0]).to eq(
      "#{g}/lib/test.rb#{e}:#{g}3#{e}: in #{q}#{c}#{label("Integer", "/")}#{e}'"
    )
    expect(exception.backtrace[1]).to eq(
      "#{g}/lib/test.rb#{e}:#{g}3#{e}: in #{q}#{c}#{label("BacktraceProbe", "inner")}#{e}'"
    )
    expect(exception.backtrace[2]).to eq(
      "#{g}/lib/test.rb#{e}:#{g}6#{e}: in #{q}#{c}#{label("BacktraceProbe", "outer")}#{e}'"
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
