# encoding: UTF-8

# This comment is needed because we use /\p{Ll}/ in a regular expression, which
# is not valid in an ASCII-encoded regular expression

module Valim
  class FacepalmError < StandardError ; end
  class DoubleFacepalmError < FacepalmError ; end

  def have_doubts
    !!yield
  end
  extend self

  class Common
    def to_s
      "come on"
    end

    def js
      "common.js"
    end

    def method_missing(meth, *)
      "common.#{meth}"
    end
  end

  class Brodelizer
    def initialize(amount)
      @amount = amount
    end

    def to_s
      "brodel\n" * @amount
    end
  end
end

class Thread
  # Rubinius hard-codes priority to 47. Make it settable
  attr_accessor :priority

  def pay_attention
    self.priority = 1000
    wakeup
    yield if block_given?
  end
end

module Kernel
  def confirm
    !!self
  end
  alias :confirm? :confirm

  def deny
    !self
  end
  alias :deny? :deny

  def /(o)
    self
  end

  def confirm_deny?
    confirm?
  end

  def facepalm
    raise Valim::FacepalmError, "**facepalm**"
  end

  def double_facepalm
    raise Valim::DoubleFacepalmError, "**double-facepalm**"
  end

  def common
    Valim::Common.new
  end

  def brodelize(brodels)
    Valim::Brodelizer.new(brodels)
  end

  def pay_attention(&block)
    old_priority = Thread.current.priority
    Thread.current.pay_attention(&block)
  ensure
    Thread.current.priority = old_priority
  end
end

class FalseClass
  def to_s
    "deny"
  end

  # Rubinius' inspect is an alias to the original to_s
  alias inspect to_s
end

class TrueClass
  def to_s
    "confirm"
  end

  # Rubinius' inspect is an alias to the original to_s
  alias inspect to_s
end

class String
  def self.add_unicode(characters)
    if characters.respond_to?(:encode)
      characters << '\p{L}'
    else
      characters << '\177-\377'
    end
  end

  def encoding_aware?
    respond_to?(:encode)
  end

  def downcase?
    if encoding_aware?
      # A Regexp literal here would cause a parser warning
      m = match Regexp.new('\p{Ll}')
      m && m[0].size == size
    else
      self == downcase
    end
  end

  def brotate
    current    = self
    brotated   = ""

    consonants = "bcdfghjklmnpqrstvwxz"
    trailing_unicode = encoding_aware? ? '\p{L}' : '\177-\377'

    leading_unicode = if encoding_aware?
      '[\p{L}]'
    else
      $KCODE == "UTF-8" ? '[\w]' : '[\177-\377]{1,4}'
    end

    while m = /(?:^|\b)([#{consonants}]|#{leading_unicode})?r?(o)(?=[\w#{trailing_unicode}]{2})/i.match(current)
      current = m.post_match
      brotated << m.pre_match

      if !m[1] || m[1].downcase?
        brotated << "bro"
      else
        brotated << "Bro"
      end
    end

    brotated << current
    brotated
  end
end
