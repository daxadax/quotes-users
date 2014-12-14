module Users
  class ServiceFactory < ServiceRegistration

    ServiceRegistration.register :users_backend do
      raise "\n\n~~~~~{[  No registration found for :users_backend  ]}~~~~~\n\n"
    end

  end
end
