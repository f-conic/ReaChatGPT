import argparse
import openai


def main(prompt):
    openai.organization = "ORG-ID"
    openai.api_key = "API-KEY"

    model_engine = "text-davinci-003"

    response = openai.Completion.create(engine=model_engine, prompt=prompt, max_tokens=1000)

    print(response.choices[0].text.strip())


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("prompt")
    args = parser.parse_args()
    main(args.prompt)
