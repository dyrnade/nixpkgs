{ buildPythonPackage
, lib
, fetchFromGitHub
, pythonOlder
, cookiecutter
, filelock
, importlib-metadata
, regex
, requests
, numpy
, protobuf
, sacremoses
, tokenizers
, tqdm
}:

buildPythonPackage rec {
  pname = "transformers";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sBMCzEgYX6HQbzoEIYnmMdpYecCCsQjTdl2mO1Veu9M=";
  };

  propagatedBuildInputs = [
    cookiecutter
    filelock
    numpy
    protobuf
    regex
    requests
    sacremoses
    tokenizers
    tqdm
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # Many tests require internet access.
  doCheck = false;

  postPatch = ''
    sed -ri 's/tokenizers==[0-9.]+/tokenizers/g' setup.py
  '';

  pythonImportsCheck = [ "transformers" ];

  meta = with lib; {
    homepage = "https://github.com/huggingface/transformers";
    description = "State-of-the-art Natural Language Processing for TensorFlow 2.0 and PyTorch";
    changelog = "https://github.com/huggingface/transformers/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ danieldk pashashocky ];
  };
}
