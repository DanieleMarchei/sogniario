// from: https://medium.com/@sangimed/complete-guide-to-sending-emails-through-an-smtp-server-with-nestjs-d75972dee394

import { ISendMailOptions, MailerService } from '@nestjs-modules/mailer';
import { Injectable, Logger } from '@nestjs/common';

@Injectable()
export class MailService {
	private readonly logger = new Logger(MailService.name);

	constructor(private readonly mailerService: MailerService) { }

	async sendEmail(params: {
		email: string,
		subject: string;
		template: string;
		context: ISendMailOptions['context'];
	}) {
		try {
			const sendMailParams = {
				to: params.email,
				from: process.env.SMTP_FROM,
				subject: params.subject,
				template: params.template,
				context: params.context,
			};
			const response = await this.mailerService.sendMail(sendMailParams);
			// this.logger.log(
			// 	`Email sent successfully to recipients with the following parameters : ${JSON.stringify(
			// 		sendMailParams,
			// 	)}`,
			// 	response,
			// );
		} catch (error) {
			this.logger.error(
				`Error while sending mail with the following parameters : ${JSON.stringify(
					params,
				)}`,
				error,
			);
		}
	}
}
