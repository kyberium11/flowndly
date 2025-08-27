import { URLSearchParams } from 'node:url';

const refreshToken = async ($) => {
  const params = new URLSearchParams({
    client_id: $.auth.data.clientId,
    client_secret: $.auth.data.clientSecret,
    grant_type: 'refresh_token',
    refresh_token: $.auth.data.refreshToken,
  });

  const { data } = await $.http.post('/oauth/token', params.toString(), {
    additionalProperties: {
      skipAddingBaseUrl: true,
    },
  });

  await $.auth.set({
    accessToken: data.access_token,
    expiresIn: data.expires_in,
    tokenType: data.token_type,
  });
};

export default refreshToken;
