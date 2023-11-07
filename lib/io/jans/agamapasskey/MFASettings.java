package io.jans.agamapasskey;

public class MFASettings {
    
    private int minCredsRequired;
    private List<String> supportedMethods;
    
    public int getMinCredsRequired() {
        return minCredsRequired;
    }
    
    public void setMinCredsRequired(int minCredsRequired) {
        this.minCredsRequired = minCredsRequired;
    }
    
    public List<String> getSupportedMethods() {
        return supportedMethods;
    }
    
    public void setSupportedMethods(List<String> supportedMethods) {
        this.supportedMethods = supportedMethods;
    }
  
}
