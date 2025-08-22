import { registerPlugin } from '@capacitor/core';

import type { CustomerIoPlugin } from './definitions';

const CustomerIo = registerPlugin<CustomerIoPlugin>('CustomerIo', {
  web: () => import('./web').then(m => new m.CustomerIoWeb()),
});

export * from './definitions';
export { CustomerIo };