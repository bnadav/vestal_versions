module VestalVersions
  module Associations
    extend ActiveSupport::Concern
    module ClassMethods
     def has_many(name, scope = nil, options = {}, &extension)
       versioned = options.delete(:versioned)
       versioned ||= scope.delete(:versioned) if scope.respond_to?(:delete)
       super(name, scope, options, &extension)
       if versioned
         assoc_klass = self.reflect_on_association(name).klass
         define_association_changed
         add_after_save_hook(assoc_klass)
       end
     end
     private

     def define_association_changed
       class << self
         def association_changed(assoc_instance)
           puts "#{assoc_instance} Changed !!"
         end
       end
     end

     def add_after_save_hook(assoc_klass)
       parent_class = self
       assoc_klass.class_eval do
         after_save do
           parent_class.association_changed(self)
         end
       end
     end
    end
  end
end
