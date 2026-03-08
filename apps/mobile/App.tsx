import { StatusBar } from 'expo-status-bar';
import { Text, View } from 'react-native';
import { client } from './api/client';
import { styles } from './styles';
import useSWR from 'swr';

export default function App() {
  const { data, error } = useGreeting("World");

  if (error) return <Text>Error loading greeting</Text>;
  if (!data) return <Text>Loading...</Text>;

  return (
    <View style={styles.container}>
      <Text>{data.message}</Text>
      <StatusBar style="auto" />
    </View>
  );
}

async function fetchGreeting(name: string) {
  const { data, error } = await client.GET("/greeting/{name}", {
    params: { path: { name } },
  });
  if (error || !data) {
    throw new Error("Failed to fetch greeting");
  }
  return data;
}

export function useGreeting(name: string) {
  return useSWR(["greeting", name], ([, keyName]) => fetchGreeting(keyName));
}

