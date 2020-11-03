require 'onelogin/ruby-saml'

class AcsController < ApplicationController
  def index
    settings = get_saml_settings
    request = Onelogin::RubySaml::Authrequest.new
    redirect_to(request.create(settings))
  end

  def consume
    response = Onelogin::RubySaml::Response.new(params[:SAMLResponse])

    # insert identity provider discovery logic here
    response.settings = get_saml_settings

    logger.info "NAMEID: #{response.name_id}"

    if response.is_valid?
      session[:userid] = response.name_id
      redirect_to :action => :complete
    else
      redirect_to :action => :fail
    end
  end

  private

  def get_saml_settings
    settings = OneLogin::RubySaml::Settings.new

    settings.assertion_consumer_service_url = "https://dev-1488456.okta.com/app/slack/exkfyaubp87EmKS885d5/sso/saml"
    settings.sp_entity_id                   = "https://dev-1488456.okta.com/app/exkfyaubp87EmKS885d5/sso/saml/metadata"
    settings.idp_entity_id                  = "http://www.okta.com/exkfyaubp87EmKS885d5"
    settings.idp_sso_target_url             = "https://app.onelogin.com/trust/saml2/http-post/sso/#{OneLoginAppId}"
    settings.idp_slo_target_url             = "https://app.onelogin.com/trust/saml2/http-redirect/slo/#{OneLoginAppId}"
    settings.idp_cert_fingerprint           = OneLoginAppCertFingerPrint
    settings.idp_cert_fingerprint_algorithm = "http://www.w3.org/2000/09/xmldsig#sha1"
    settings.name_identifier_format         = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"

    # Optional for most SAML IdPs
    settings.authn_context = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
    # or as an array
    settings.authn_context = [
        "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport",
        "urn:oasis:names:tc:SAML:2.0:ac:classes:Password"
    ]

    # Optional bindings (defaults to Redirect for logout POST for acs)
    settings.single_logout_service_binding      = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"
    settings.assertion_consumer_service_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"

    settings
  end
end
