module Responsys
  module Api
    module Folder
      def list_folders
        api_method(:list_folders)
      end

      def create_folder(name)
        api_method(:create_folder, { :folderName => name })
      end

      def delete_folder(name)
        api_method(:delete_folder, { :folderName => name })
      end

      def folder_exists?(name)
        all = list_folders

        all.select! { |curr_folder| curr_folder[:name] == name }

        !all.empty?
      end
    end
  end
end