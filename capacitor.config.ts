import { CapacitorConfig } from '@capacitor/cli';

// Define the configuration with strict typing first
const baseConfig: CapacitorConfig = {
  appId: 'io.viaswift.app',
  appName: 'ViaSwift',
  webDir: 'dist',
  // For production deployment to app stores, use bundled mode
  // Comment out the server section when building for app stores
  /*
  server: {
    androidScheme: 'https',
    iosScheme: 'https',
    url: 'https://viaswift-api.replit.app',
    cleartext: true
  }
  */
  // App store version should use bundled web content
  bundledWebRuntime: true,
  // Version information for app stores
  appVersion: '1.0.0',
  appBuild: '1'
};

// Then cast to any to add extended properties
const config = {
  ...baseConfig,
  // Extended properties can be added here
  plugins: {
    SplashScreen: {
      launchShowDuration: 3000,
      backgroundColor: "#222222",
      androidSplashResourceName: "splash",
      androidScaleType: "CENTER_CROP"
    },
    Geolocation: {
      locationWhenInUsePermissionDescription: "We need your location to find rides and deliveries near you.",
      locationAlwaysPermissionDescription: "We need your location to track rides and deliveries."
    },
    LocalNotifications: {
      smallIcon: "ic_stat_notification",
      iconColor: "#FF9800"
    }
  }
} as CapacitorConfig;

export default config;
