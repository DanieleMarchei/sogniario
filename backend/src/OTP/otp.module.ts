import { Module } from "@nestjs/common";
import { TypeOrmModule } from "@nestjs/typeorm";
import { OTP } from "src/entities/otp.entity";
import { OTPController } from "./otp.controller";
import { OTPService } from "./otp.service";
import { OTPGuard } from "./otp.guard";
import { APP_GUARD } from "@nestjs/core";
import { UserModule } from "src/User/user.module";
import { MailModule } from "src/mail/mail.module";
import { OrganizationModule } from "src/Organization/organization.module";

@Module({
	imports: [TypeOrmModule.forFeature([OTP]), UserModule, OrganizationModule, MailModule],
	controllers: [OTPController],
	providers: [
		OTPService,
		// {
		// 	provide: APP_GUARD,
		// 	useClass: OTPGuard
		// }
	],
})
export class OTPModule { }
