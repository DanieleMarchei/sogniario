import { Module } from '@nestjs/common';
import { TasksService } from './task.service';
import { UserService } from 'src/User/user.service';
import { OTPService } from 'src/OTP/otp.service';
import { UserModule } from 'src/User/user.module';
import { OTPModule } from 'src/OTP/otp.module';
import { DataSource } from 'typeorm';

@Module({
  imports: [OTPModule],
  providers: [TasksService],
})
export class TasksModule {}