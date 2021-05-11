module ApplicationHelper
    def is_active(c_name,m_name)
        (controller_name == c_name and action_name == m_name) ? "active" : ""
    end
end
