
import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { file } from 'jszip';
import { User } from 'src/entities/user.entity';
import { OTPService } from 'src/OTP/otp.service';
import { UserService } from 'src/User/user.service';
import { DataSource } from 'typeorm';

@Injectable()
export class TasksService {
	constructor(
		private otpService: OTPService,
	) { }
	private readonly logger = new Logger(TasksService.name);


	@Cron("00 00 12 * * 1") // every monday at 12:00:00 am
	deleteAllInvalidOTPs() {
		this.otpService.deleteInvalidOTP();
		this.logger.debug('Deleted all invalid OTPS');
	}

	@Cron("00 00 12 * * 2") // every tuesday at 12:00:00 am
	async backupDatabase() {
		var exec = require('child_process').exec;
		var today = new Date().toLocaleDateString("it-IT").split("/").join(".");
		var file_name = `sogniario_${today}.backup`;
		
		var dump_command = `YOUR DUMP COMMAND`;

		// if the backup is saved directly into the correct location, use this code
		exec(dump_command, (error, stdout, stderr) => {
			if (error !== null) {
				this.logger.warn("error during dump command");
				this.logger.error(error);
				this.logger.error(stderr);
			}else{
				this.logger.log("Backup completed");
			}
		});
		

		// if you are using podman for saving, use this code
		// var bkp_folder = process.env.BACKUP_FOLDER;
		// var container_name = process.env.CONTAINER_NAME;
		// exec(dump_command, (error, stdout, stderr) => {
		// 	if (error !== null) {
		// 		this.logger.warn("error during dump command");
		// 		this.logger.error(error);
		// 		this.logger.error(stderr);
		// 	} else {
		// 		var save_command = `podman cp ${container_name}:/${file_name} ${bkp_folder}`;
		// 		exec(save_command, (error, stdout, stderr) => {
		// 			if (error !== null) {
		// 				this.logger.warn("error during save command");
		// 				this.logger.error(error);
		// 				this.logger.error(stderr);
		// 			} else {
		// 				var rm_command = `podman exec ${container_name} rm ${file_name}`;
		// 				exec(rm_command, (error, stdout, stderr) => {
		// 					if (error !== null) {
		// 						this.logger.warn("error during rm command");
		// 						this.logger.error(error);
		// 						this.logger.error(stderr);
		// 					} else {
		// 						this.logger.log("Backup completed");

		// 					}

		// 				});
		// 			}
		// 		});
		// 	}
		// });


	}
}
