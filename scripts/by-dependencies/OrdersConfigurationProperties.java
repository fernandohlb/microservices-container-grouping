package works.weave.socks.orders.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.core.env.Environment;

import java.net.URI;

@ConfigurationProperties
public class OrdersConfigurationProperties {
    private String domain = "";

    @Autowired
    private Environment env;

    public URI getPaymentUri() {
        String hostname = env.getProperty("hostname.payment");
        return new ServiceUri(new Hostname(hostname), new Domain(domain), "/paymentAuth").toUri();
    }

    public URI getShippingUri() {
        String hostname = env.getProperty("hostname.shipping");
        return new ServiceUri(new Hostname(hostname), new Domain(domain), "/shipping").toUri();
    }

    public void setDomain(String domain) {
        this.domain = domain;
    }

    private class Hostname {
        private final String hostname;

        private Hostname(String hostname) {
            this.hostname = hostname;
        }

        @Override
        public String toString() {
            if (hostname != null && !hostname.equals("")) {
                return hostname;
            } else {
                return "";
            }
        }
    }

    private class Domain {
        private final String domain;

        private Domain(String domain) {
            this.domain = domain;
        }

        @Override
        public String toString() {
            if (domain != null && !domain.equals("")) {
                return "." + domain;
            } else {
                return "";
            }
        }
    }

    private class ServiceUri {
        private final Hostname hostname;
        private final Domain domain;
        private final String endpoint;

        private ServiceUri(Hostname hostname, Domain domain, String endpoint) {
            this.hostname = hostname;
            this.domain = domain;
            this.endpoint = endpoint;
        }

        public URI toUri() {
            return URI.create(wrapHTTP(hostname.toString() + domain.toString()) + endpoint);
        }

        private String wrapHTTP(String host) {
            return "http://" + host;
        }

        @Override
        public String toString() {
            return "ServiceUri{" +
                    "hostname=" + hostname +
                    ", domain=" + domain +
                    '}';
        }
    }
}
