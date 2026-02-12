import { ApiProperty } from "@nestjs/swagger";
import { AfterInsert, AfterLoad, AfterUpdate, Column, Entity, ManyToOne, PrimaryGeneratedColumn, VirtualColumn } from "typeorm";
import { User } from "./user.entity";
import PostgresInterval, { IPostgresInterval } from "postgres-interval";
import * as sanitizeHtml from 'sanitize-html';
import { Expose, Transform, TransformFnParams, Exclude } from "class-transformer";

@Entity()
export class Psqi {
  @ApiProperty()
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty({ type: 'time'})
  @Column({type: "time"})
  @Transform((params: TransformFnParams) => sanitizeHtml(params.value , {
    disallowedTagsMode: 'recursiveEscape',
    allowedTags: [],
    allowedAttributes: {}
}))
  q1: string;
  
  @ApiProperty({ type: "number" })
  @Column()
  q2: number;
  
  @ApiProperty({ type: 'time'})
  @Column({type: "time" })
  @Transform((params: TransformFnParams) => sanitizeHtml(params.value , {
    disallowedTagsMode: 'recursiveEscape',
    allowedTags: [],
    allowedAttributes: {}
}))
  q3: string;

  @ApiProperty()
  @Column({ type: 'interval' })
  q4: IPostgresInterval;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5a: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5b: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5c: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5d: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5e: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5f: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5g: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5h: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5i: number;

  @ApiProperty({ type: "boolean" })
  @Column()
  q5j: boolean;

  @ApiProperty()
  @Column({ nullable: true })
  @Transform((params: TransformFnParams) => sanitizeHtml(params.value , {
    disallowedTagsMode: 'recursiveEscape',
    allowedTags: [],
    allowedAttributes: {}
}))
  q5j_text: String;

  @ApiProperty({ type: "number", nullable : true })
  @Column({ nullable: true })
  q5j_frequency: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q6: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q7: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q8: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q9: number;

  @ApiProperty()
  @Column({ type: "timestamptz", default: () => "CURRENT_TIMESTAMP" })
  compiled_date: Date;

  @ApiProperty({ type: () => User })
  @ManyToOne(() => User, (user) => user.psqis)
  user: User;


  score: number;

  c1: number;
  c2: number;
  c3: number;
  c4: number;
  c5: number;
  c6: number;
  c7: number;

  // @AfterInsert()
  @AfterLoad()
  @AfterUpdate()
  computeScore(){

    let final_score = -1000;
    let c1 = -1000;
    let c2 = -1000;
    let c3 = -1000;
    let c4 = -1000;
    let c5 = -1000;
    let c6 = -1000;
    let c7 = -1000;

    try {
      [final_score, c1, c2, c3, c4, c5, c6, c7] = computeScore(this);
      
    } catch (error) {
      console.log(`WARNIGN!\nPSQI ${this.id} raised an error during score calculation. ${error}`);
    }

    this.score = final_score;
    this.c1 = c1;
    this.c2 = c2;
    this.c3 = c3;
    this.c4 = c4;
    this.c5 = c5;
    this.c6 = c6;
    this.c7 = c7;


  }

}


class TimeOfDay{
  hours: number;
  minutes: number;
  seconds: number;

  constructor(hours: number = 0, minutes: number = 0, seconds: number = 0) {
    this.seconds = seconds;
    this.minutes = minutes;
    this.hours = hours;
  }

  difference(other: TimeOfDay) : TimeOfDay{
    let sec_diff = this.to_seconds_from_midnight() - other.to_seconds_from_midnight();
    if(sec_diff < 0){
      sec_diff = other.to_seconds_until_midnight() + this.to_seconds_from_midnight();
    }
    let date = new Date(sec_diff * 1000);
    let hours = date.getUTCHours();
    let minutes = date.getUTCMinutes();
    let seconds = date.getUTCSeconds();
    return new TimeOfDay(hours, minutes, seconds);
  }

  to_seconds_from_midnight(): number{
    return this.seconds + this.minutes * 60 + this.hours * 3600
  }

  to_seconds_until_midnight(): number{
    return 24 * 60 * 60 - this.to_seconds_from_midnight()
  }

  toString(): string {
    return `${this.hours}:${this.minutes}:${this.seconds}`;
  }

  static parse(s: string): TimeOfDay{
    let values = s.split(":");
    let h = Number.parseInt(values[0]);
    let m = Number.parseInt(values[1]);
    let sec = Number.parseInt(values[2]);
    return new TimeOfDay(h, m, sec);
  }
}

function mapValueFromInterval(
  value : number, 
  intervalsWithResults : Array<[number, number, number]>,
  name : string
){

  for (let interval of intervalsWithResults) {
    let [from, to, result] = interval;
    if(from <= value && value <= to){
      // console.log(`${name}=${value} is between ${from} and ${to}, therefore ${result}.`);
      return result;
    }
    
  }

  throw RangeError(`Not enough interval to cover all possibilities: ${value} is not inside ${intervalsWithResults}`);
}

function computeScore(psqi : Psqi) : [number, number, number, number, number, number, number, number]{
  let ninf = Number.NEGATIVE_INFINITY;
  let inf = Number.POSITIVE_INFINITY;
  // #9 score
  let c1 = psqi.q9;

  // #2 Score (<=15min (0), 16-30min (1), 31-60 min (2), >60min (3))
  // + #5a Score (if sum is equal 0=0; 1-2=1; 3-4=2; 5-6=3) 
  var two = mapValueFromInterval(psqi.q2, [
    [ninf, 15, 0],
    [16, 30, 1],
    [31, 60, 2],
    [61, inf, 3],
  ],
  "psqi.q2"
);

  let fiveA = psqi.q5a;
  let c2 = mapValueFromInterval(fiveA + two, [
    [0, 0, 0],
    [1, 2, 1],
    [3, 4, 2],
    [5, 6, 3],
  ],
  `fiveA ${fiveA} + two ${two}`
);


  // #4 Score (>7(0), 6-7 (1), 5-6 (2), <5 (3) numero A
  let q4_minutes = psqi.q4.minutes === null || psqi.q4.minutes === undefined ? 0 : psqi.q4.minutes
  let hoursOfSleep = Math.round(psqi.q4.hours + q4_minutes / 60);
  let c3 = mapValueFromInterval(hoursOfSleep, [
    [ninf, 4, 3],
    [5, 6, 2], 
    [6, 7, 1],
    [8, inf, 0],
  ],
  `hoursOfSleep`
);


  // (total # of hours asleep)/(total # of hours in bed) x 100     (4a / 4b)
  // >85%=0, 75%-84%=1, 65%-74%=2, <65%=3
  let t_tosleep = TimeOfDay.parse(psqi.q1);
  let t_wakeup = TimeOfDay.parse(psqi.q3);
  
  let hoursInBed = t_wakeup.difference(t_tosleep);
  let hib = hoursInBed.hours + hoursInBed.minutes / 60;
  let fraction = Math.round((hoursOfSleep / hib) * 100);
  let c4 = mapValueFromInterval(fraction, [
    [85, inf, 0],
    [75, 84, 1],
    [65, 74, 2],
    [ninf, 64, 3],
  ],
  `fraction (${hoursOfSleep} / ${hib})`
);

  // Sum of Scores #5b to #5j (0=0; 1-9=1; 10-18=2; 19-27=3).
  let opf = psqi.q5j_frequency === null ? 0 : psqi.q5j_frequency;
  let sumBtoJ = psqi.q5b + 
                psqi.q5c + 
                psqi.q5d + 
                psqi.q5e + 
                psqi.q5f + 
                psqi.q5g + 
                psqi.q5h + 
                psqi.q5i + 
                opf;
  let c5 = mapValueFromInterval(sumBtoJ, [
    [0, 0, 0],
    [1, 9, 1],
    [10, 18, 2],
    [19, 27, 3],
  ],
  `sumBtoJ (opf is ${opf})`
);

  // #6 Score
  let c6 = psqi.q6;

  // #7 Score + #8 Score (0=0; 1-2=1; 3-4=2; 5-6=3)
  let sum7and8 = psqi.q7 + psqi.q8;
  let c7 = mapValueFromInterval(sum7and8, [
    [0, 0, 0],
    [1, 2, 1],
    [3, 4, 2],
    [5, 6, 3],
  ],
  `sum7and8 (${psqi.q7}, ${psqi.q8}})`
);

  // console.log(c1 , c2 , c3 , c4 , c5 , c6 , c7)

  var final_score = c1 + c2 + c3 + c4 + c5 + c6 + c7;
  return [final_score, c1, c2, c3, c4, c5, c6, c7];

}