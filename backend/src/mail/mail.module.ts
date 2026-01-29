// from: https://medium.com/@sangimed/complete-guide-to-sending-emails-through-an-smtp-server-with-nestjs-d75972dee394

import { Module } from '@nestjs/common';
import { MailService } from './mail.service';

import { MailerModule } from '@nestjs-modules/mailer';
import { PugAdapter } from '@nestjs-modules/mailer/dist/adapters/pug.adapter';

@Module({
  imports: [
    MailerModule.forRootAsync({
      useFactory: () => ({
        transport: {
          host: process.env.SMTP_HOST,
          port: +process.env.SMTP_PORT,
          secure: true,
          auth: {
            user: process.env.SMTP_FROM,
            pass: process.env.SMTP_EMAIL_PASSWORD
          },
          tls: {
            ciphers:'SSLv3',
          },
        },
        defaults: {
          from: process.env.SMTP_FROM,
        },
        template: {
          dir: __dirname + '/../../templates',
          adapter: new PugAdapter(),
          options: {
            strict: true,
          },
        },
      }),
      imports: undefined
    }),
  ],
  providers: [MailService],
  exports: [MailService],
  controllers: []
})
export class MailModule {}
