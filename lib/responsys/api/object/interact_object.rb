module Responsys
  module Api
    module Object
      class InteractObject
        attr_accessor :folderName, :objectName

        def initialize(folderName, objectName)
          self.folderName = folderName
          self.objectName = objectName
        end

        def to_hash
          {'folderName' => folderName, 'objectName' => objectName}
        end
      end
    end
  end
end