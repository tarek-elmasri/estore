
Rails.application.config.middleware.use ActionDispatch::Cookies 

Rails.application.config.middleware.use ActionDispatch::Session::CookieStore , 
    key: "sessions",
    secure: Rails.env=="production",
    http_only: true,
    same_site: :None

Rails.application.config.middleware.insert_after ActionDispatch::Cookies , 
    ActionDispatch::Session::CookieStore,
    key: "sessions",
    secure: Rails.env=="production",
    http_only: true,
    same_site: :None

    