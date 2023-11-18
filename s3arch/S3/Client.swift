//
//  Client.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/15/23.
//

import NIO
import SotoCore
import SotoS3

let regionLookup: [String: Region] = [
  "us-east-2": .useast2,
  "us-east-1": .useast1,
  "us-west-1": .uswest1,
  "us-west-2": .uswest2,
  "af-south-1": .afsouth1,
  "ap-east-1": .apeast1,
  "ap-south-2": .apsouth2,
  "ap-southeast-3": .apsoutheast3,
  "ap-south-1": .apsouth1,
  "ap-northeast-3": .apnortheast3,
  "ap-northeast-2": .apnortheast2,
  "ap-southeast-1": .apsoutheast1,
  "ap-southeast-2": .apsoutheast2,
  "ap-northeast-1": .apnortheast1,
  "ca-central-1": .cacentral1,
  "eu-central-1": .eucentral1,
  "eu-west-1": .euwest1,
  "eu-west-2": .euwest2,
  "eu-south-1": .eusouth1,
  "eu-west-3": .euwest3,
  "eu-south-2": .eusouth2,
  "eu-north-1": .eunorth1,
  "eu-central-2": .eucentral2,
  "me-south-1": .mesouth1,
  "me-central-1": .mecentral1,
  "sa-east-1": .saeast1,
]

class S3Client {
  let keychainData: KeychainData
  let client: AWSClient
  let s3: S3

  init(keychainData: KeychainData) {
    self.keychainData = keychainData
    self.client = AWSClient(
      credentialProvider: .static(
        accessKeyId: keychainData.accessKey, secretAccessKey: keychainData.accessKeySecret),
      httpClientProvider: .createNew
    )

    self.s3 = S3(client: client, region: .useast2)
  }

  func listBucketNames() -> EventLoopFuture<[String]> {
    let future = s3.listBuckets(logger: Logger(label: "Logger"))

    return future.map { response in
      return response.buckets?.compactMap { $0.name } ?? []
    }
  }
}
