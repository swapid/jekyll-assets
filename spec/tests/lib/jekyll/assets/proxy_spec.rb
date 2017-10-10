# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"

# --
module Jekyll
  module Assets
    module Plugins
      class ProxyTest1 < Proxy
        args_key :test
        types :test

        def process
          nil
        end
      end

      #

      class ProxyTest2 < Proxy
        args_key :test
        types :test

        def process
          nil
        end
      end
    end
  end
end

#

describe Jekyll::Assets::Proxies do
  let :args do
    args = "ubuntu.png @test:2x"
    Liquid::Tag::Parser.
      new(args)
  end

  #

  let :asset do
    env.manifest.find(args[:argv1]).first
  end

  #

  it "should call the proxy" do
    klass = Jekyll::Assets::Plugins::ProxyTest1
    expect_any_instance_of(klass).to(receive(:process))
    expect(klass).to(receive(:new).and_call_original)
    subject.run_proxies(:test, {
      args: args, env: env, asset: asset
    })
  end

  #

  it "should return an asset" do
    out = subject.run_proxies(:test, {
      args: args,
      asset: asset,
      env: env,
    })

    expect(out).to(be_a(Sprockets::Asset))
    expect(out.filename).to(eq(Pathutil.new(env.
      in_cache_dir(subject::DIR)).children.
        first.to_s))
  end

  #

  it "should copy the asset" do
    subject.run_proxies(:test, args: args, env: env, asset: asset)
    dir = Pathutil.new(env.in_cache_dir(subject::DIR))
    expect(dir.children.size).to(eq(1))

    expect(dir.children.first.binread).to(eq(Pathutil.
      new(asset.filename).binread))
  end
end
