import React, { useState, useEffect } from 'react';
import { getNotificationSettingsAPI, updateNotificationSettingsAPI } from '../services/api';
import toast from 'react-hot-toast';

const NotificationSettings = () => {
  const [settings, setSettings] = useState({
    email_notifications: true,
    push_notifications: true,
  });

  useEffect(() => {
    const fetchSettings = async () => {
      try {
        const response = await getNotificationSettingsAPI();
        setSettings(response.data);
      } catch (error) {
        console.error('Failed to fetch notification settings:', error);
        toast.error('Failed to load notification settings');
      }
    };
    fetchSettings();
  }, []);

  const handleChange = (e) => {
    setSettings({ ...settings, [e.target.name]: e.target.checked });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await updateNotificationSettingsAPI(settings);
      toast.success('Notification settings updated successfully');
    } catch (error) {
      console.error('Failed to update notification settings:', error);
      toast.error('Failed to update notification settings');
    }
  };

  return (
    <div>
      <h2>Notification Settings</h2>
      <form onSubmit={handleSubmit}>
        <div>
          <label>
            <input
              type="checkbox"
              name="email_notifications"
              checked={settings.email_notifications}
              onChange={handleChange}
            />
            Email Notifications
          </label>
        </div>
        <div>
          <label>
            <input
              type="checkbox"
              name="push_notifications"
              checked={settings.push_notifications}
              onChange={handleChange}
            />
            Push Notifications
          </label>
        </div>
        <button type="submit">Save Settings</button>
      </form>
    </div>
  );
};

export default NotificationSettings;
