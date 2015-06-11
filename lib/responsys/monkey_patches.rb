module Responsys
  module MonkeyPatches
    module Object
      #Ruby 2
      def try(*a, &b)
        if a.empty? && block_given?
          yield self
        else
          __send__(*a, &b)
        end
      end unless method_defined?(:try)

      def blank?
        respond_to?(:empty?) ? empty? : !self
      end unless method_defined?(:blank?)

      def present?
        !blank?
      end unless method_defined?(:present?)

    end

    module NilClass
      def try(*args)
        nil
      end unless method_defined?(:try)

    end
  end
end

Object.send(:include, Responsys::MonkeyPatches::Object)
NilClass.send(:include, Responsys::MonkeyPatches::NilClass)