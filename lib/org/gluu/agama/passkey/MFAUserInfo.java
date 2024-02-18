package org.gluu.agama.passkey;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class MFAUserInfo {

    @JsonProperty("enrolled_methods")
    private List<String> enrolledMethods;

    @JsonProperty("total_creds")
    private int count;

    @JsonProperty("turned_on")
    private boolean turnedOn;

    private String preference;

    public boolean isTurnedOn() {
        return turnedOn;
    }

    public List<String> getEnrolledMethods() {
        return enrolledMethods;
    }

    public int getCount() {
        return count;
    }

    public String getPreference() {
        return preference;
    }

    public void setTurnedOn(boolean turnedOn) {
        this.turnedOn = turnedOn;
    }

    public void setEnrolledMethods(List<String> enrolledMethods) {
        this.enrolledMethods = enrolledMethods;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public void setPreference(String preference) {
        this.preference = preference;
    }

    @Override
    public String toString() {
        return "MFAUserInfo{" +
                "enrolledMethods=" + enrolledMethods +
                ", count=" + count +
                ", turnedOn=" + turnedOn +
                ", preference='" + preference + '\'' +
                '}';
    }
}
