package io.jans.agamapasskey.zoho;

public class AuthSettings {
    
    private boolean enabled;
    private String clientId;
    private String clientSecret;
    private String refreshToken;
    private String accountsUrl;
    
    public boolean isEnabled() {
        return enabled;
    }
    
    public String getClientId() {
        return clientId;
    }
    
    public String getClientSecret() {
        return clientSecret;
    }
    
    public String getRefreshToken() {
        return refreshToken;
    }
    
    public String getAccountsUrl() {
        return accountsUrl;
    }
    
    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }
    
    public void setClientId(String clientId) {
        this.clientId = clientId;
    }
    
    public void setClientSecret(String clientSecret) {
        this.clientSecret = clientSecret;
    }
    
    public void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }
    
    public void setAccountsUrl(String accountsUrl) {
        this.accountsUrl = accountsUrl;
    }

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((accountsUrl == null) ? 0 : accountsUrl.hashCode());
		result = prime * result + ((clientId == null) ? 0 : clientId.hashCode());
		result = prime * result + ((clientSecret == null) ? 0 : clientSecret.hashCode());
		result = prime * result + ((refreshToken == null) ? 0 : refreshToken.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this === obj)  //Using == will execute this.equals(obj) -> stackoverflow. This is not exactly Java, but Groovy...
			return true;
		if (obj === null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		AuthSettings other = (AuthSettings) obj;
		if (accountsUrl == null) {
			if (other.accountsUrl != null)
				return false;
		} else if (!accountsUrl.equals(other.accountsUrl))
			return false;
		if (clientId == null) {
			if (other.clientId != null)
				return false;
		} else if (!clientId.equals(other.clientId))
			return false;
		if (clientSecret == null) {
			if (other.clientSecret != null)
				return false;
		} else if (!clientSecret.equals(other.clientSecret))
			return false;
		if (refreshToken == null) {
			if (other.refreshToken != null)
				return false;
		} else if (!refreshToken.equals(other.refreshToken))
			return false;
		return true;
	}

}
