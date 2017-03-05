# name: discourse-moderator-signature
# about: A plugin created for Resolute Legal
# version: 1.0.0
# author: Darren Nickerson
# url: http://www.darrennickerson.com

enabled_site_setting :signatures_enabled

DiscoursePluginRegistry.serialized_current_user_fields << "see_signatures"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_url"
DiscoursePluginRegistry.serialized_current_user_fields << "signature_raw"

after_initialize do

  User.register_custom_field_type('see_signatures', :boolean)
  User.register_custom_field_type('signature_url', :text)
  User.register_custom_field_type('signature_raw', :text)

  if SiteSetting.signatures_enabled then
    add_to_serializer(:post, :user_signature, false) {
      if SiteSetting.signatures_advanced_mode then
        object.user.custom_fields['signature_raw']
      else
        object.user.custom_fields['signature_url']
      end
    }

    # I guess this should be the default @ discourse. PR maybe?
    add_to_serializer(:user, :custom_fields, false) {
      if object.custom_fields == nil then
        {}
      else
        object.custom_fields
      end
    }
  end
end

register_asset "javascripts/discourse/templates/connectors/user-custom-preferences/signature-preferences.hbs"
register_asset "stylesheets/common/signatures.scss"
