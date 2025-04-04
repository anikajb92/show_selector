require 'bundler/setup'
Bundler.require

require_all 'lib'

# Problem on Ruby 2.7
# > BigDecimal(1).to_s("F")
# (pry):1: warning: rb_check_safe_obj will be removed in Ruby 3.0
# This monkeypatch silences it.
# TODO: remove when on Ruby 3+
module BigDecimalFormatWarningSuppressor
    # NOTE: this API comes from ActiveSupport::NumericWithFormat, the last ancestor prepended to
    # BigDecimal.
    def to_s(format = nil, options = nil)
      original_verbosity = $VERBOSE
      $VERBOSE = nil
      v = super
      $VERBOSE = original_verbosity
      v
    end
  end
  
  BigDecimal.prepend(BigDecimalFormatWarningSuppressor)