#
# A SAML service provider controller
#

class SamlController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:acs]
  # skip_before_action :require_authentication
  # skip_before_action :require_authorization

  #
  # GET /saml/login
  #
  # SP initiated login action. Redirects to IdP.
  #
  def login
    request = OneLogin::RubySaml::Authrequest.new
    redirect_to(request.create(saml_settings))
  end

  #
  # POST /saml/acs
  #
  # Assertion Consumer Service URL. The endpoint that the IdP posts to.
  #
  def acs
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse], :settings => saml_settings)
    puts response

    byebug

    Rails.logger.info("Response: #{response.name_id}")
    # reset_session
    session[:user_id] = response.name_id
    redirect_to root_path
  end

  #
  # POST /saml/logout
  #
  def logout
    reset_session
    redirect_to root_path
  end

  private

  def saml_settings
    @settings ||= begin
                    # if ENV['IDP_METADATA_URL'] && ENV['IDP_METADATA_URL'].present?
                    #   OneLogin::RubySaml::IdpMetadataParser.new.parse_remote('https://dev-1488456.okta.com/app/exkfyaubp87EmKS885d5/sso/saml/metadata')
                    OneLogin::RubySaml::IdpMetadataParser.new.parse_remote('https://dev-1488456.okta.com/app/exkdnrv49II4QFLLg5d5/sso/saml/metadata')
                    # else
                    #   raise StandardError, "The environment variable IDP_METADATA_URL is not set."
                    # end
                  end
  end

end