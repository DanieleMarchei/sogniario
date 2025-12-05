
import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { OTPService } from 'src/OTP/otp.service';
import { UserService } from 'src/User/user.service';

@Injectable()
export class TasksService {
	constructor(
		private userService: UserService,
		private otpService: OTPService,
	) { }
	private readonly logger = new Logger(TasksService.name);


	@Cron("00 00 12 * * 1") // every monday at 12:00:00 am
	handleCron() {
		this.otpService.deleteInvalidOTP();
		this.logger.debug('Deleted all invalid OTPS');
	}
}
