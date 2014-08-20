module Responsys
  module Api
    module Object
      class InteractObject
        attr_accessor :folder_name, :object_name

        def initialize(folder_name, object_name)
          self.folder_name = folder_name
          self.object_name = object_name
        end

        def to_api
          { folderName: folder_name, objectName: object_name }
        end
      end
    end
  end
end