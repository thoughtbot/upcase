
module StackDeck
  module ExceptionSupport
    def higher_stack_deck; @higher_stack_deck ||= []; end
    def append_to_stack_deck(frames)
      higher_stack_deck.concat(frames)
      set_backtrace_from_stack_deck!
    end
    def stack_deck(stop_at_boundary=true)
      deck = []
      deck.concat(internal_stack_deck || []) if respond_to? :internal_stack_deck
      deck.concat higher_stack_deck
      remainder = @stack_deck_backtrace_remaining || backtrace
      deck.concat StackDeck::Frame::Ruby.extract(remainder) if remainder
      deck.compact!
      StackDeck.apply_boundary!(deck) if stop_at_boundary
      deck
    end
    def copy_ruby_stack_to_deck(ignored_part=caller)
      @stack_deck_backtrace_remaining ||= backtrace
      upper_backtrace, lower_backtrace = StackDeck.split_list(@stack_deck_backtrace_remaining, ignored_part)
      higher_stack_deck.concat StackDeck::Frame::Ruby.extract(upper_backtrace)
      @stack_deck_backtrace_remaining = lower_backtrace
      set_backtrace_from_stack_deck!
    end
    def set_backtrace_from_stack_deck!
      @stack_deck_backtrace_remaining ||= backtrace
      set_backtrace_without_stack_deck stack_deck(false).map {|fr| fr.to_s }
    end
    def set_backtrace_with_stack_deck(frames)
      @stack_deck_backtrace_remaining = nil
      @higher_stack_deck = []
      set_backtrace_without_stack_deck frames
    end
  end
end

class Exception
  include StackDeck::ExceptionSupport
  alias :set_backtrace_without_stack_deck :set_backtrace
  alias :set_backtrace :set_backtrace_with_stack_deck
end

