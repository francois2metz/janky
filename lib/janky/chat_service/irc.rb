module Janky
  module ChatService
    class IRC
      def initialize(settings)
      end

      def speak(message, room_id, options = {:color => "yellow"})
      end

      def rooms
        []
      end
    end
  end

  register_chat_service "irc", ChatService::IRC
end
