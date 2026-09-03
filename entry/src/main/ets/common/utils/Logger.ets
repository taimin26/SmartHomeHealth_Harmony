/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import hilog from '@ohos.hilog';

export class Logger {
  private static readonly domain: number = 0xFF00;
  private static readonly tag: string = '[MyHarmony]';
  private static readonly format: string = "[%{public}s] --> %{public}s";
  private static readonly format2: string = "%{public}s";

  constructor() {
  }

  static debug(...args: Object[]): void {
    hilog.debug(Logger.domain, Logger.tag, args.length == 2 ? Logger.format : Logger.format2, args);
  }

  static info(...args: Object[]): void {
    hilog.info(Logger.domain, Logger.tag, args.length == 2 ? Logger.format : Logger.format2, args);
  }

  static warn(...args: Object[]): void {
    hilog.warn(Logger.domain, Logger.tag, args.length == 2 ? Logger.format : Logger.format2, args);
  }

  static error(...args: Object[]): void {
    hilog.error(Logger.domain, Logger.tag, args.length == 2 ? Logger.format : Logger.format2, args);
  }
}
