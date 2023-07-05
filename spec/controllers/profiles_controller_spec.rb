require 'rails_helper'

@user = User.create(
  first_name: "Maria",
  last_name: "Doew",
  email: "maria@example.com",
  password: "password",
  country: "Brasil",
  city: "São Paulo",
  state: "SP",
  professional_field: "Tecnologia",
  academic_degree: "Ciências da Computação"
)

RSpec.describe PagesController, type: :controller do
  describe "GET #home" do
    it "redirects user to home page when accessing the root URL" do
      get :home
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:home)
    end
  end

end
