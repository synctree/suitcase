module Suitcase
  class SessionCache
    def initialize(store)
      @store = store
    end

    def save_session(session)
      @store.push session
    end

    def get_session(session_id)
      @store.find { |session| session.session_id == session_id }
    end

    def delete_session(session_id)
      @store.delete get_session(session_id)
    end

    def count
      @store.count
    end

    def push(item)
      @store.push item
    end
  end
end
